--难 以 接 受 的 结 果
function c46564015.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c46564015.target)
	e1:SetOperation(c46564015.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetTarget(c46564015.target)
	e2:SetOperation(c46564015.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c46564015.target)
	e3:SetOperation(c46564015.activate)
	c:RegisterEffect(e3)
end
function c46564015.cfilter(c,tp)
	return c:IsSetCard(0x650)
end
function c46564015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c46564015.cfilter,1,nil,tp)
end
function c46564015.filter(c,e,tp)
	return c:IsSetCard(0x650) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46564015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c46564015.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c46564015.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c46564015.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end











