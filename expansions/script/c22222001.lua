--爆裂冲锋
function c22222001.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c22222001.dtg)
	e2:SetOperation(c22222001.dop)
	c:RegisterEffect(e2)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c22222001.thtg)
	e2:SetOperation(c22222001.thop)
	c:RegisterEffect(e2)
end
c22222001.named_with_Shirasawa_Tama=1
function c22222001.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22222001.dfilter(c)
	return c:IsFaceup() and c22222001.IsShirasawaTama(c) and c:IsAbleToRemove()
end
function c22222001.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22222001.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22222001.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22222001.dfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22222001.dop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsLocation(LOCATION_MZONE) then return false end
	local seq=tc:GetSequence()
	local g=Group.CreateGroup()
	if seq==0 or seq==2 or seq==4 then
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq)) end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,seq) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,seq)) end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)) end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)) end
	end
	if seq==1 or seq==5 then
	if Duel.GetFieldCard(tp,LOCATION_MZONE,1) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,1)) end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,5) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,5)) end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,1) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,1)) end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)) end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,3) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,3)) end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,3) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,3)) end
	end
	if seq==3 or seq==6 then
	if Duel.GetFieldCard(tp,LOCATION_MZONE,3) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,3)) end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,6) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,6)) end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,3) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,3)) end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)) end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,1) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,1)) end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,1) then g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,1)) end
	end
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end
function c22222001.tgfilter(c)
	return c:IsAbleToRemove()
end
function c22222001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22222001.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,0)
end
function c22222001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22222001.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end