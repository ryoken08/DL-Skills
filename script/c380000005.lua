--Balance
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_MONSTER)
	   and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_SPELL)
	   and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_TRAP)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local dr=Duel.GetStartingHand(tp)
		local ct=dr-1
		local deck=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		--get total count of each card type
		local mnt=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)/deck*ct
		local spl=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL)/deck*ct
		local trp=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP)/deck*ct
		--check cards to add 1 of said type 
		local g1=nil
		local tc=nil
		if mnt>spl and mnt>trp then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(tp,1)
			tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif spl>mnt and spl>trp then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL):RandomSelect(tp,1)
			tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif trp>mnt and trp>spl then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP):RandomSelect(tp,1)
			tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif mnt==spl and spl==trp then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,1)
			tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif mnt==spl and spl~=trp then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL):RandomSelect(tp,ct)
			Duel.MoveToDeckTop(g1)
		elseif spl==trp and mnt~=spl then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,ct)
			Duel.MoveToDeckTop(g1)
		elseif mnt==trp and spl~=trp then
			g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_TRAP):RandomSelect(tp,ct)
			Duel.MoveToDeckTop(g1)
		end
		--always at least 1 of each
		for i=1,2 do
			local g=Duel.GetDecktopGroup(tp,dr)
			local ctm=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
			local cts=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
			local ctt=g:FilterCount(Card.IsType,nil,TYPE_TRAP)
			if ctm==0 then
				local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(tp,1)
				local sg1=sg:GetFirst()
				Duel.MoveToDeckTop(sg1)
			end
			if cts==0 then
				local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL):RandomSelect(tp,1)
				local sg1=sg:GetFirst()
				Duel.MoveToDeckTop(sg1)
			end
			if ctt==0 then
				local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP):RandomSelect(tp,1)
				local sg1=sg:GetFirst()
				Duel.MoveToDeckTop(sg1)
			end
		end
		--cannot use monster effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		--cannot Special Summon
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
	end
	e:SetLabel(1)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
