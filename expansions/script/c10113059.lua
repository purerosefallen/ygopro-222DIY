--炎龙剑
function c10113059.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c10113059.fscon)
	e0:SetOperation(c10113059.fsop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10113059.splimit)
	c:RegisterEffect(e1) 
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10113059.sprcon)
	e2:SetOperation(c10113059.sprop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10113059,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c10113059.eqtg)
	e3:SetOperation(c10113059.eqop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	--fusion limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c10113059.eqfilter(c,ec)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:CheckEquipTarget(ec)
end
function c10113059.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10113059.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10113059.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10113059.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end
function c10113059.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10113059.spfilter1(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c10113059.spfilter2,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil)
end
function c10113059.spfilter2(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsCanBeFusionMaterial(nil,true) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c10113059.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10113059.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
end
function c10113059.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c10113059.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c10113059.spfilter2,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c10113059.filter1(c)
	return c:IsRace(RACE_DRAGON)
end
function c10113059.filter2(c)
	return bit.band(c:GetType(),0x40002)==0x40002
end
function c10113059.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c10113059.filter1
	local f2=c10113059.filter2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return (f1(gc) and mg:IsExists(f2,1,gc))
			or (f2(gc) and mg:IsExists(f1,1,gc)) end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end
end
function c10113059.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c10113059.filter1
	local f2=c10113059.filter2
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		local sg=Group.CreateGroup()
		if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=f1(tc1)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
	if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
