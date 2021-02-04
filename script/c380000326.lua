--Volcanic Burning Deck
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
s.listed_names={33365932,32543380,69537999,21420702}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	for i=1,2 do
		local token=Duel.CreateToken(tp,33365932)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	local token2=Duel.CreateToken(tp,32543380)
	Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
	local token3=Duel.CreateToken(tp,69537999)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
	local token4=Duel.CreateToken(tp,21420702)
	Duel.SendtoDeck(token4,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	--Add flag to activate the other skills
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetOperation(s.checkop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.checkop2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetLabelObject(e2)
		e3:SetCondition(s.flipcon)
		e3:SetOperation(s.flipop)
		Duel.RegisterEffect(e3,tp)
	end
	e:SetLabel(1)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Blaze Accelerator
	if re:GetHandler():IsCode(69537999) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep==tp then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	--Tri-Blaze Accelerator
	if re:GetHandler():IsCode(21420702) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep==tp then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		e:SetLabel(Duel.GetTurnCount())
	end
end
function s.filter(c,chk,chk2)
	return (chk and c:IsCode(21420702)) or (chk2 and c:IsCode(32543380))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 and Duel.GetFlagEffect(ep,id+1)>0 then return end
	local b1=e:GetHandler():GetFlagEffect(id)==1 and Duel.GetFlagEffect(ep,id)==0
		and e:GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
	local b2=e:GetHandler():GetFlagEffect(id+1)==1 and Duel.GetFlagEffect(ep,id+1)==0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,b1,b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=e:GetHandler():GetFlagEffect(id)==1 and Duel.GetFlagEffect(ep,id)==0
		and e:GetLabelObject():GetLabelObject():GetLabel()~=Duel.GetTurnCount()
	local b2=e:GetHandler():GetFlagEffect(id+1)==1 and Duel.GetFlagEffect(ep,id+1)==0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,b1,b2)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_RULE)
		--add flag if you added Tri-Blaze Accelerator
		if tc:IsCode(21420702) then
			--opd register
			Duel.RegisterFlagEffect(ep,id,0,0,0)
		end
		--add flag if you added Volcanic Doomfire
		if tc:IsCode(32543380) then
			--opd register
			Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
