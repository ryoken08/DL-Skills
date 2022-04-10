--Level Cannon / Lock-on Laser
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
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x13}
s.listed_names={86997073}
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x13)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
s.filter=aux.FilterFaceupFunction(Card.IsCode,86997073)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local b1=(Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO))
	local b2=(Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP))
	return aux.CanActivateSkill(tp) and (b1 or b2)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.GetLP(1-tp)>=3000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local b1=(Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO))
	local b2=(Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--Select 1 Synchro Monster on your opponent's field
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_MZONE,1,1,nil,TYPE_SYNCHRO)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			--Decrease your opponent's Life Points by that Synchro Monster Original Level x 100
			local lp=Duel.GetLP(1-tp)-(tc:GetOriginalLevel()*100)
			Duel.SetLP(1-tp, lp)
		end
	else
		--Decrease your opponent's Life Points by the number of Spell/Trap Cards on their field x100
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		if ct>0 then
			local lp=Duel.GetLP(1-tp)-(ct*100)
			Duel.SetLP(1-tp, lp)
		end
	end
end
