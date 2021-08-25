--ZEXAL - Xyz Evolution
local ZEXAL=380000353
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.checkcon,s.checkop)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={11705261}
s.listed_series={0x107f}
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 or Duel.GetFlagEffect(ep,ZEXAL)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0
	and Duel.GetTurnPlayer()==tp
	and Duel.GetLP(tp)<=2000
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--ZeXal register
	Duel.RegisterFlagEffect(ep,ZEXAL,0,0,0)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107f) and c:IsType(TYPE_EXTRA)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil))
	--ZeXal check
	if Duel.GetFlagEffect(ep,ZEXAL)==0 then return end
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil))
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if opt==0 then
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		local token=Duel.CreateToken(tp,11705261)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--ask if you want to make your Life Points 2000
		if Duel.GetLP(tp)<2000 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.SetLP(tp,2000)
		end
	else
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
