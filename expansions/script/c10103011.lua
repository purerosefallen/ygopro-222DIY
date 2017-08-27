--界限龙 阿勒克托
function c10103011.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10103011)
	e1:SetCondition(c10103011.sscon)
	e1:SetTarget(c10103011.sstg)
	e1:SetOperation(c10103011.ssop)
	c:RegisterEffect(e1)
	--rit summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10103011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10103111)
	e2:SetTarget(c10103011.eftg)
	e2:SetOperation(c10103011.efop)
	c:RegisterEffect(e2)
	c10103011[c]=e2  
end
function c10103011.effilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c[c]
	if not te or c:GetOriginalCode()<10103001 or c:GetOriginalCode()>10103099 or c:IsCode(10103011) or c:GetOriginalLevel()~=4 then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
	return true
end
function c10103011.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c10103011.effilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c10103011.effilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c10103011.effilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local te=tc[tc]
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10103011.efop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10103011.sfilter(c)
	return c:IsSetCard(0x1337) and c:IsFaceup()
end
function c10103011.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10103011.sfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10103011.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10103011.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end