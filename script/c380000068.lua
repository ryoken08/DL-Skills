--Master of Rites
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not s[tp] then s[tp]=Duel.GetLP(tp) end
	if s[tp]>Duel.GetLP(tp) then
		s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
		s[tp]=Duel.GetLP(tp)
	end
	if not s[1-tp] then s[1-tp]=Duel.GetLP(1-tp) end
	if s[1-tp]>Duel.GetLP(1-tp) then
		s[2+(1-tp)]=s[2+(1-tp)]+(s[1-tp]-Duel.GetLP(1-tp))
		s[1-tp]=Duel.GetLP(1-tp)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	local b1=Duel.IsExistingMatchingCard(Card.IsRitualMonster,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsRitualSpell,tp,LOCATION_DECK,0,1,nil)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and s[2+tp]>=1000
	and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	local b1=Duel.IsExistingMatchingCard(Card.IsRitualMonster,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsRitualSpell,tp,LOCATION_DECK,0,1,nil)
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	local sg=nil
	if opt==0 then
		sg=Duel.GetMatchingGroup(Card.IsRitualMonster,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
	else
		sg=Duel.GetMatchingGroup(Card.IsRitualSpell,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
	end
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,sg)
		s[2+tp]=0
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
