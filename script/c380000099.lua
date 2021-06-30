--Teacherly Discipline
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
function s.checkop()
	for tp=0,1 do
		if not s[tp] then s[tp]=Duel.GetLP(tp) end
		if s[tp]>Duel.GetLP(tp) then
			s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
			s[tp]=Duel.GetLP(tp)
		end
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
	and s[2+tp]>=1500
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,70,71,72)
	local g=nil
	if op==0 then
		g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(1-tp,1)
	elseif op==1 then
		g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_SPELL):RandomSelect(1-tp,1)
	elseif op==2 then
		g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_TRAP):RandomSelect(1-tp,1)
	end
	if #g>0 then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveToDeckTop(g:GetFirst())
	end
	s[2+tp]=0
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
