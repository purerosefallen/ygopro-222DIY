--口袋妖怪 巨金怪
function c80000112.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c80000112.ffilter,2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000112.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_EXTRA)
	e12:SetCondition(c80000112.spcon)
	e12:SetOperation(c80000112.spop)
	c:RegisterEffect(e12)   
	--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c80000112.efilter)
	c:RegisterEffect(e13)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c80000112.adjustop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_MAX_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(c80000112.mvalue)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_MAX_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(c80000112.svalue)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c80000112.desreptg)
	e5:SetOperation(c80000112.desrepop)
	c:RegisterEffect(e5)
end
function c80000112.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x2d0)
end
function c80000112.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000112.spfilter1(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x2d0) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c80000112.spfilter2,1,c)
end
function c80000112.spfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x2d0)
end
function c80000112.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80000112.spfilter1,1,nil,tp)
end
function c80000112.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80000112.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c80000112.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c80000112.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c80000112.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local c2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if c1>4 or c2>4 then
		local g=Group.CreateGroup()
		if c1>4 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,c1-4,c1-4,nil)
			g:Merge(g1)
		end
		if c2>4 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,c2-4,c2-4,nil)
			g:Merge(g2)
		end
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Readjust()
	end
end
function c80000112.mvalue(e,fp,rp,r)
	return 4-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function c80000112.svalue(e,fp,rp,r)
	local ct=4
	for i=4,7 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then ct=ct-1 end
	end
	return ct-Duel.GetFieldGroupCount(fp,LOCATION_MZONE,0)
end
function c80000112.repfilter(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c80000112.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c80000112.repfilter,tp,LOCATION_SZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(80000112,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c80000112.repfilter,tp,LOCATION_SZONE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c80000112.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end