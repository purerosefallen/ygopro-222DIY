--haku
function c10113040.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10113040)
	e1:SetCost(c10113040.spcost)
	e1:SetCondition(c10113040.spcon)
	e1:SetTarget(c10113040.sptg)
	e1:SetOperation(c10113040.spop)
	c:RegisterEffect(e1) 
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113040,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10113040.recon)
	e2:SetTarget(c10113040.retg)
	e2:SetOperation(c10113040.reop)
	c:RegisterEffect(e2)	
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(10113020)
	c:RegisterEffect(e3)  
end
c10113040.card_code_list={10113020}
function c10113040.recon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetOriginalCode()==10113030
end
function c10113040.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c10113040.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c10113040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c10113040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113040.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10113040.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c10113040.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c10113040.filter(c,e,tp)
	return c:IsCode(10113050) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c10113040.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10113040.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10113040.filter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end