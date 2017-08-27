--库拉丽丝-血泪
function c57300009.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetLabel(2)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c57300009.xyzcon)
	e1:SetOperation(c57300009.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57300009,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,57300009)
	e2:SetCost(c57300009.tdcost)
	e2:SetTarget(c57300009.tdtg)
	e2:SetOperation(c57300009.tdop)
	c:RegisterEffect(e2)
end
function c57300009.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x570) and c:IsCanBeXyzMaterial(xyzc) and c:IsXyzLevel(xyzc,2)
end
function c57300009.xyzfilter(c,mg,sg,ct,min,max,tp,xyzc)
	sg:AddCard(c)
	local i=sg:GetCount()
	local res=(i>=min and c57300009.xyzgoal(sg,ct,tp,xyzc))
		or (i<max and mg:IsExists(c57300009.xyzfilter,1,sg,mg,sg,ct,min,max,tp,xyzc))
	sg:RemoveCard(c)
	return res
end
function c57300009.xyzgoal(g,ct,tp,xyzc)
	local i=g:GetCount()
	if not g:CheckWithSumEqual(c57300009.xyzval,ct,i,i) then return false end
	--to be changed in mr4
	--return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 
end
function c57300009.xyzval(c)
	local v=1
	if c:IsHasEffect(57300021) then v=v+0x20000 end
	return v
end
function c57300009.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c57300009.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300009.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	return min<=max and mg:IsExists(c57300009.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c)
end
function c57300009.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		if not min then
			local tg=Group.CreateGroup()
			for tc in aux.Next(og) do
				tg:Merge(tc:GetOverlayGroup())
			end
			c:SetMaterial(og)
			Duel.SendtoGrave(tg,REASON_RULE)
			Duel.Overlay(c,og)
			return
		end
		mg=og:Filter(c57300009.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c57300009.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local ct=e:GetLabel()
	local sg=Group.CreateGroup()
	local min=min or 1
	local max=max and math.min(max,ct) or ct
	local i=sg:GetCount()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c57300009.xyzfilter,1,1,sg,mg,sg,ct,min,max,tp,c)
		sg:Merge(g)
		i=sg:GetCount()
	until i>=max or (i>=min and c57300009.xyzgoal(sg,ct,tp,xyzc) and not (mg:IsExists(c57300009.xyzfilter,1,sg,mg,sg,ct,min,max,tp,c) and Duel.SelectYesNo(tp,210)))
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tg:Merge(tc:GetOverlayGroup())
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)  
end
function c57300009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c57300009.tdfilter(c)
	return c:IsAbleToRemove()
end
function c57300009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c57300009.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c57300009.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c57300009.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c57300009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end