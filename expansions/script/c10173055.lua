--超能回弹士
function c10173055.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c10173055.fscon)
	e1:SetOperation(c10173055.fsop)
	c:RegisterEffect(e1)
	--rjp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10173055.reptg)
	e2:SetOperation(c10173055.repop)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c10173055.tfcon)
	e3:SetOperation(c10173055.tfop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetDescription(aux.Stringid(10173055,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c10173055.tdtg)
	e4:SetOperation(c10173055.tdop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CUSTOM+10173055)
	c:RegisterEffect(e5)
end
function c10173055.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10173055.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c10173055.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c10173055.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g,re=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	if chk==0 then return c:IsFaceup() and c:GetReasonPlayer()~=tp and (not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g:IsContains(c))  end
	return true
end
function c10173055.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_REDIRECT+REASON_TEMPORARY+REASON_EFFECT)
end
function c10173055.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetLabelObject()==re
end
function c10173055.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10173055)
	if Duel.ReturnToField(c,POS_FACEUP_DEFENSE) then
	   Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10173055,e,0,tp,0,0)
	end
end
function c10173055.ffilter(c,fc)
	return not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c10173055.ffilter2(c,mg)
	return mg:IsExists(c10173055.ffilter3,1,c,c)
end
function c10173055.ffilter3(c,rc)
	local att=0
	local catt=1
	for iatt=0,7 do
		if c:IsFusionAttribute(catt) and rc:IsFusionAttribute(catt) then
		return true
		end
		catt=catt*2
	end
	return false
end
function c10173055.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(c10173055.ffilter,nil,e:GetHandler())
	if gc then
		mg:AddCard(gc)
		return c10173055.ffilter(gc,e:GetHandler()) and mg:IsExists(c10173055.ffilter2,1,nil,mg)
	end
	local fs=false
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:IsExists(c10173055.ffilter2,1,nil,mg) and (fs or chkf==PLAYER_NONE)
end
function c10173055.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=eg:Filter(c10173055.ffilter,gc,e:GetHandler())
	if gc then
		sg=sg:Filter(c10173055.ffilter3,gc,gc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g)
		return
	end
	local tc=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then tc=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf):GetFirst()
	else tc=sg:Select(tp,1,1,nil):GetFirst()
	end
	sg=sg:Filter(c10173055.ffilter3,tc,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=sg:Select(tp,1,1,nil)
	g:AddCard(tc)
	Duel.SetFusionMaterial(g)
end