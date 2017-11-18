--降临之地 利维艾拉
local m=22251501
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+1
function c22251501.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22251501,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,22251501)
	e2:SetTarget(c22251501.tgtg)
	e2:SetOperation(c22251501.tgop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22251501,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCondition(c22251501.sccon)
	e2:SetTarget(c22251501.sctg)
	e2:SetOperation(c22251501.scop)
	c:RegisterEffect(e2)
	--turn back side
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c22251501.con)
	e3:SetOperation(c22251501.op)
	c:RegisterEffect(e3)
end
c22251501.named_with_Riviera=1
function c22251501.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22251501.filter(c)
	return c22251501.IsRiviera(c) and c:IsFaceup()
end
function c22251501.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22251501.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c22251501.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
end
function c22251501.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c22251501.sfilter(c,e,tp)
	return c22251501.IsRiviera(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_FAIRY)
end
function c22251501.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251501.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function c22251501.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22251501.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,fale,false,POS_FACEUP)
	end
end
function c22251501.tgfilter(c)
	return c:IsAbleToGrave() and c22251501.IsRiviera(c) and c:IsFaceup()
end
function c22251501.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22251501.tgfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c22251501.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c22251501.tgfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,1,tp,0)
end
function c22251501.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end