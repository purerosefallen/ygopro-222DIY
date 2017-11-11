--Riviera 艾克塞尔
function c22250001.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22250001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,222500011)
	e1:SetCondition(c22250001.spcon)
	e1:SetTarget(c22250001.sptg)
	e1:SetOperation(c22250001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22250001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,222500012)
	e3:SetCondition(c22250001.cecon)
	e3:SetTarget(c22250001.cetg)
	e3:SetOperation(c22250001.ceop)
	c:RegisterEffect(e3)
end
c22250001.named_with_Riviera=1
function c22250001.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22250001.fspfilter(c,e,tp,mg,chkf)
	return c22250001.IsRiviera(c) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c22250001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return rp==tp and eg:GetCount()==1 and c22250001.IsRiviera(tc) and not tc:IsImmuneToEffect(e)
end
function c22250001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local c=e:GetHandler()
	local mg=Group.FromCards(c,tc)
	local chkf=tp
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp,tp,tc)>0 and Duel.IsExistingMatchingCard(c22250001.fspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,LOCATION_EXTRA)
end
function c22250001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local mg=Group.FromCards(c,tc)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or (not c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (not c:IsRelateToEffect(e)) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c22250001.fspfilter,tp,LOCATION_EXTRA,0,1,nil,e,mg,tp,nil,chkf) and Duel.GetLocationCountFromEx(tp,tp,tc)>0 and tc:IsLocation(LOCATION_MZONE) and mg:IsExists(Card.IsRace,1,nil,RACE_FAIRY) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c22250001.fspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,nil,chkf)
		local tc=sg:GetFirst()
		tc:SetMaterial(mg)
		Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c22250001.xfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c22250001.IsRiviera(c) and c:IsControler(tp)
end
function c22250001.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local tp=e:GetHandler():GetControler()
	return g:IsExists(c22250001.xfilter,1,nil,tp)
end
function c22250001.cefilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp,oc)
	return oc~=c and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c22250001.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22250001.cefilter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c22250001.cefilter,tp,LOCATION_MZONE,0,1,nil,re,rp,tf,ceg,cep,cev,cre,cr,crp,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22250001.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangeTargetCard(ev,Group.FromCards(c))
		if c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(22250001,2)) then
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end