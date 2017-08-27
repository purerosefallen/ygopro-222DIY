--结合魔术
function c10113023.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot disable spsum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10113023.cdsstg)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10113023.sumcon)
	e3:SetOperation(c10113023.sumsuc)
	c:RegisterEffect(e3)	
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10113023,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c10113023.spcon)
	e4:SetTarget(c10113023.sptg)
	e4:SetOperation(c10113023.spop)
	c:RegisterEffect(e4)
end
function c10113023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c10113023.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION+TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113023.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10113023.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10113023.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10113023.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10113023.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(10113023,1)) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c10113023.cdsstg(e,c)
	local mg=c:GetMaterial()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ)~=0 and mg:GetCount()>=2
end
function c10113023.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10113023.sumfilter,1,nil,tp)
end
function c10113023.sumfilter(c,tp)
	local mg=c:GetMaterial()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_RITUAL+SUMMON_TYPE_FUSION)~=0 and mg:GetCount()>=2
end
function c10113023.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c10113023.chainlm)
end
function c10113023.chainlm(e,rp,tp)
	return tp==rp
end