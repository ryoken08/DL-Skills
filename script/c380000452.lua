--Heaven, Earth, and People
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={31930787,4545683,68140974}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetOperation(s.checkop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.checkop2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_NEGATED)
		e3:SetLabelObject(e2)
		e3:SetOperation(s.checkop3)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetLabelObject(e3)
		e4:SetCondition(s.flipcon)
		e4:SetOperation(s.flipop)
		Duel.RegisterEffect(e4,tp)
	end
	e:SetLabel(1)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	--"Meklord Emperor Skiel" inflicts battle damage to your opponent with a direct attack
	if eg:GetFirst():GetControler()==tp and eg:GetFirst():IsCode(31930787) and ep~=tp and Duel.GetAttackTarget()==nil then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	--"Meklord Emperor Granel" inflicts 3000 or more battle damage
	if eg:GetFirst():IsCode(4545683) and ep~=tp and ev>=3000 then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.checkop3(e,tp,eg,ep,ev,re,r,rp)
	--Activated the last effect of your "Meklord Emperor Wisel"
	if rp==tp and re:GetHandler():IsCode(68140974) or not re:GetHandler():IsType(TYPE_SPELL) then return end
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	if dp==tp then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local b1=(e:GetHandler():GetFlagEffect(id)==1 and Duel.GetFlagEffect(ep,id)==0
		and e:GetLabelObject():GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,4545683))
	local b2=(e:GetHandler():GetFlagEffect(id+1)==1 and Duel.GetFlagEffect(ep,id+1)==0
		and e:GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,68140974))
	local b3=(e:GetHandler():GetFlagEffect(id+2)==1 and Duel.GetFlagEffect(ep,id+2)==0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,31930787))
	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(e:GetHandler():GetFlagEffect(id)==1 and Duel.GetFlagEffect(ep,id)==0
		and e:GetLabelObject():GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,4545683))
	local b2=(e:GetHandler():GetFlagEffect(id+1)==1 and Duel.GetFlagEffect(ep,id+1)==0
		and e:GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,68140974))
	local b3=(e:GetHandler():GetFlagEffect(id+2)==1 and Duel.GetFlagEffect(ep,id+2)==0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,31930787))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)},
	{b3,aux.Stringid(id,3)})
	if op==1 then
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--Add 1 "Meklord Emperor Granel" to your hand from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,4545683)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		end
	elseif op==2 then
		--opd register
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		--Add 1 "Meklord Emperor Wisel" to your hand from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,68140974)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		end
	else
		--opd register
		Duel.RegisterFlagEffect(ep,id+2,0,0,0)
		--Add 1 "Meklord Emperor Skiel" to your hand from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,31930787)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		end
	end
	--Return 1 card in your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end	
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
