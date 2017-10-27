--Ryu☆ L.E.D.
local m=37564110
local cm=_G["c"..m]
function cm.initial_effect(c)
--xmlm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c37564110.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
--ss
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(37564110,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,37564110)
	e5:SetCost(c37564110.cost)
	e5:SetTarget(c37564110.target)
	e5:SetOperation(c37564110.operation)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(37564110,ACTIVITY_SPSUMMON,c37564110.counterfilter)
--lv
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37564110,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c37564110.lvop)
	c:RegisterEffect(e4)
--tune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e6)
end
function c37564110.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x772)
end
function c37564110.rsfilter(c,e,tp)
	return c:IsCode(37564110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37564110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetCustomActivityCount(37564110,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c37564110.exlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c37564110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(c37564110.rsfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c37564110.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37564110.rsfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37564110.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(4)
		c:RegisterEffect(e1)
	end
end
function c37564110.exlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x772) and c:IsLocation(LOCATION_EXTRA)
end
function c37564110.counterfilter(c)
	return c:IsSetCard(0x772) or c:GetSummonLocation()~=LOCATION_EXTRA
end
